From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: mdadm 3.3: issue with mdmon --takeover
Date: Wed, 4 Sep 2013 09:36:27 +0200
Message-ID: <CAC9WiBiHkOjqY4nDwMh4S8td9NMz2mrdqK0R7cZp7nKSMyhBvg@mail.gmail.com>
References: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>
	<20130904160832.3627bcb8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130904160832.3627bcb8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Wed, Sep 4, 2013 at 8:08 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 3 Sep 2013 17:54:55 +0200 Francis Moreau <francis.moro@gmail.com>
> wrote:
>
>> Hello Martin :)
>>
>> I gave 3.3 release a try and I have a first issue: basically starting
>> mdmon (3.3) with --takeover twice make mdmon failing on the second
>> run.
>>
>> Please find details below:
>>
>> # cat /proc/mdstat
>> Personalities : [raid1]
>> md126 : active raid1 sdb[1] sda[0]
>>       2064384 blocks super external:/md127/0 [2/2] [UU]
>>
>> md127 : inactive sdb[1](S) sda[0](S)
>>       65536 blocks super external:ddf
>>
>> # ps aux | grep dmon
>> root       311  0.4  1.0  80580 10944 ?        SLsl 17:46   0:00
>> @sbin/mdmon --takeover md127
>>
>> # ./mdmon --takeover --all
>>
>> # ps aux | grep dmon
>> root      3182  1.3  1.0  15156 11056 ?        SLsl 17:50   0:00
>> ./mdmon --takeover md127
>>
>> # ./mdmon --takeover --all
>> ...
>> monitor: wake ( )
>> monitor: wake ( )
>> monitor: wake ( )
>> monitor: wake ( )
>> monitor: wake ( )
>> monitor: wake ( 12:array_state )
>> read_and_act(0): 1378223477.512347 state:clean prev:clean action:idle
>> prev: idle start:18446744073709551615
>> ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (5) clean 18446744073709551615
>> manage_new: inst: 0 action: 11 state: 12
>> mdmon: ddf_open_new: subarray 0 doesn't exist
>> mdmon: failed to monitor external:/md127/0
>> free_aa: sys_name: md126
>> read_and_act(0): state:clean action:idle next( )
>> manage_new: inst: 0 action: 20 state: 21
>> ddf_open_new: new subarray 0, GUID: Linux-MDdeadbeef00000000?Ob79e0c8b1n
>> free_aa: sys_name: md126
>> caught sigterm, all clean... exiting
>> monitor: wake ( )
>> no arrays to monitor... exiting
>>
>> # ps aux | grep dmon
>> #
>>
>> Thanks
>
> I can't easily reproduce this.

This is weird, it's 100% reproductible here.

>
> Can you run "mdmon --takeover" in one window, then the next "mdmon
> --takeover" is a different window so we can clearly see which messages are
> coming from the mdmon which is exiting and which are coming from the mdmon
> which is starting.


Sure.

A note that I should have probably tell previously: before I'm
starting manually the first mdmon process, an old mdmon process is
running which was started by the system at boot and this mdmon is
3.2.6.

###
### window 1: starting manually the first mdmon --takeover process ####
###

# ps aux | grep dmon
root       312  0.5  1.0  80580 10944 ?        SLsl 09:24   0:00
@sbin/mdmon --takeover md127

## Note: this mdmon process was started at system boot and is 3.2.6

# ./mdmon --takeover --all
...
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
manage_new: inst: 0 action: 11 state: 12
ddf_open_new: new subarray 0, GUID: Linux-MDdeadbeef00000000?Ob79e0c8b1n
monitor: caught signal
read_and_act(0): 1378279619.393600 state:clean prev:inactive
action:idle prev: idle start:18446744073709551615
pr_state/ddf_set_array_state: 0(s=10 i=02)
ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (5) dirty 18446744073709551615
pr_state/ddf_set_array_state: 0(s=00 i=02)
ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (5) clean 18446744073709551615
pr_state/__write_init_super_ddf: 0(s=00 i=02)
writing conf record 0 on disk b342fbdc for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
writing conf record 0 on disk b342fbdc for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
writing conf record 0 on disk 2cf00056 for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
writing conf record 0 on disk 2cf00056 for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
ddf: sync_metadata
read_and_act(0): state:clean action:idle next( )
monitor: wake ( 12:array_state )
read_and_act(0): 1378279621.980656 state:write-pending prev:clean
action:idle prev: idle start:18446744073709551615
pr_state/ddf_set_array_state: 0(s=10 i=02)
ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (7) dirty 18446744073709551615
pr_state/__write_init_super_ddf: 0(s=10 i=02)
writing conf record 0 on disk b342fbdc for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
writing conf record 0 on disk b342fbdc for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
writing conf record 0 on disk 2cf00056 for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
writing conf record 0 on disk 2cf00056 for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
ddf: sync_metadata
read_and_act(0): state:write-pending action:idle next( state:active )
monitor: wake ( 12:array_state )
read_and_act(0): 1378279622.381087 state:active prev:write-pending
action:idle prev: idle start:18446744073709551615
read_and_act(0): state:active action:idle next( )
monitor: wake ( 12:array_state )
read_and_act(0): 1378279626.520845 state:active-idle prev:active
action:idle prev: idle start:18446744073709551615
read_and_act(0): state:active-idle action:idle next( state:clean )
monitor: wake ( 12:array_state )
read_and_act(0): 1378279626.524532 state:clean prev:active-idle
action:idle prev: idle start:18446744073709551615
pr_state/ddf_set_array_state: 0(s=00 i=02)
ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (5) clean 18446744073709551615
pr_state/__write_init_super_ddf: 0(s=00 i=02)
writing conf record 0 on disk b342fbdc for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
writing conf record 0 on disk b342fbdc for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
writing conf record 0 on disk 2cf00056 for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
writing conf record 0 on disk 2cf00056 for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
ddf: sync_metadata
read_and_act(0): state:clean action:idle next( )
monitor: wake ( 12:array_state )
read_and_act(0): 1378279626.981157 state:write-pending prev:clean
action:idle prev: idle start:18446744073709551615
pr_state/ddf_set_array_state: 0(s=10 i=02)
ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (7) dirty 18446744073709551615
pr_state/__write_init_super_ddf: 0(s=10 i=02)
writing conf record 0 on disk b342fbdc for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
writing conf record 0 on disk b342fbdc for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
writing conf record 0 on disk 2cf00056 for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
writing conf record 0 on disk 2cf00056 for
Linux-MDdeadbeef00000000?Ob79e0c8b1n/0
ddf: sync_metadata
read_and_act(0): state:write-pending action:idle next( state:active )
monitor: wake ( 12:array_state )
read_and_act(0): 1378279627.376402 state:active prev:write-pending
action:idle prev: idle start:18446744073709551615
read_and_act(0): state:active action:idle next( )

[launching new mdmon --takeover....]

monitor: wake ( 12:array_state )
read_and_act(0): 1378279678.858186 state:clean prev:clean action:idle
prev: idle start:18446744073709551615
ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (5) clean 18446744073709551615
read_and_act(0): state:clean action:idle next( )
manage_new: inst: 0 action: 20 state: 21
ddf_open_new: new subarray 0, GUID: Linux-MDdeadbeef00000000?Ob79e0c8b1n
free_aa: sys_name: md126
caught sigterm, all clean... exiting

###
### window 2: starting the 2nd mdmon process ###
###

#./mdmon --takeover --all
...
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
manage_new: inst: 0 action: 11 state: 12
mdmon: ddf_open_new: subarray 0 doesn't exist
mdmon: failed to monitor external:/md127/0
free_aa: sys_name: md126
monitor: wake ( )
no arrays to monitor... exiting


Thanks
-- 
Francis
