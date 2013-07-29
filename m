From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Suspicious test failure - mdmon misses recovery events on loop
 devices
Date: Mon, 29 Jul 2013 22:39:43 +0200
Message-ID: <51F6D30F.7060007@arcor.de>
References: <51F2E2DD.8090204@arcor.de> <20130729165550.53c33bf3@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020008070207020808000701"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130729165550.53c33bf3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020008070207020808000701
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 07/29/2013 08:55 AM, NeilBrown wrote:

> Hi Martin.
> 
>  I don't think the state change needs to happen while mdmon is in the select
>  call.  It just need to happen between one call to read_and_act, and the next.
>  And everything happens between one call and the next...
> 
>  If sync_action is 'recovery' one time and then something else that isn't
>  'idle' the next time, then that would cause the transition to get lost.
>  Can that ever happen?  Do you see a particular transition that bypasses
>  'idle'?
>  It is possible there is some race here...
> 
>  I'll try out your test script can see if I can reproduce  it.

I don't see "recover" followed by anything else but "idle". But what I
do observe is that the "recover" status isn't seen at all.

I've attached a comparison of good and bad case for the same test.

BAD CASE: mdmon processes the metadata update for the first member and
writes the metadata. when it calls read_and_act after that, the recovery
on the first array is already finished, and it will call set_disk, and
call sync_metadata() again. This double metadata write takes a long
time. Meanwhile, the manager sent the update for the second member and
started the recovery on it. When mdmon comes down to processing this
update, the recovery on the 2nd array is already finished, and it never
sees "recover" or "frozen" state on it. Consequently, it doesn't realize
that there ever was a recovery.

The example is somehow pathological because the test arrays are
unrealistically small. In normal situations we'd expect recovery to take
much longer than 2 meta data writes. However, it doesn't feel good to
know that this can happen.

My current idea to solve this is yet another separate thread just for
monitoring kernel state changes. Don't have it ready yet, though.

Martin


> 
> 
> 
>>
>> Martin
>>
>> PS: In that context, reading mdmon-design.txt, is it allowed at all to
>> add dprintf() messages in the code path called by mdmon? That would also
>> affect some DDF methods where I currently have lots of debug code.
> 
> Yes, you can have dprintf messages anywhere.  However if debugging is
> enabled, then I don't promise that mdmon will even try to survive low memory
> conditions.
> 
> NeilBrown


--------------020008070207020808000701
Content-Type: text/plain;
 name="fail-and-add_goodbad.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fail-and-add_goodbad.txt"

"*" means monitor wakeup
array (1) is the RAID10, (0) the RAID5

GOOD (2)

Monitor					Manager
					activate_spare(1)
* 1:frozen 0: idle
* process_update(1)			
  ...					activate_spare(0)
  sync_metadata				
  1: recover 0: frozen			
     	       				remove_old(md125)
*  process_update(0)
   sync_metadata
  1: recover 0: recover
* 1: recover 0: recover
					remove_old(md126)
...
* 1: idle 0: recover
  set_disk
  sync_metadata
...
* 1: clean 0: clean
  set_disk
  sync_metadata
  
BAD

Monitor					Manager
					activate_spare(1)
* 1: frozen 0: idle
* 
					remove_old(md125)
  1: recover 0: idle
* process_update(1)			
  ...					activate_spare(0)
  sync_metadata
					remove_old(md126)
  1: idle 0: idle
  set_disk
  sync_metadata
* process_update(0)
  sync_metadata
  1: idle 0: idle  (3s later)
   

--------------020008070207020808000701--
