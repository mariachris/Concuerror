%%%----------------------------------------------------------------------
%%% Copyright (c) 2013, Alkis Gotovos <el3ctrologos@hotmail.com>,
%%%                     Maria Christakis <mchrista@softlab.ntua.gr>
%%%                 and Kostis Sagonas <kostis@cs.ntua.gr>.
%%% All rights reserved.
%%%
%%% This file is distributed under the Simplified BSD License.
%%% Details can be found in the LICENSE file.
%%%----------------------------------------------------------------------
%%% Authors     : Ilias Tsitsimpis <iliastsi@hotmail.com>
%%% Description : Test shutdown exit status
%%%----------------------------------------------------------------------

-module(exit_shutdown).
-export([scenarios/0]).
-export([shutdown/0, terminate/0, check_exit_status/0, check_exit2_status/0]).

scenarios() ->
    [ {F, inf, D} ||
        F <- [shutdown, terminate, check_exit_status, check_exit2_status],
        D <- [full, dpor] ].

shutdown() ->
    %% Spawn a process that just waits.
    Pid = spawn(fun() -> receive _ -> ok end end),
    %% Send an exit signal with status shutdown to Pid.
    %% This exit code should be interpreted by Concuerror as success.
    exit(Pid, shutdown).

terminate() ->
    %% Spawn a process that just waits.
    Pid = spawn(fun() -> receive _ -> ok end end),
    %% Send an exit signal with status terminate to Pid.
    %% This exit code should be interpreted by Concuerror as error.
    exit(Pid, terminate).

check_exit_status() ->
    {Pid, Ref} = spawn_monitor(fun() -> exit(shutdown) end),
    receive
        {'DOWN', Ref, process, Pid, shutdown} ->
            ok
    end.

check_exit2_status() ->
    {Pid, Ref} = spawn_monitor(fun() -> receive ok -> ok end end),
    exit(Pid, shutdown),
    receive
        {'DOWN', Ref, process, Pid, shutdown} ->
            ok
    end.
