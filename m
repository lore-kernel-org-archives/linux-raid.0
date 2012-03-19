From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: raid10 regression: unrecoverable raids
Date: Mon, 19 Mar 2012 12:15:07 +0100
Message-ID: <4F67153B.8090900@redhat.com>
References: <4F6711AB.7010906@redhat.com> <20120319220801.23671fc5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120319220801.23671fc5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/19/12 12:08, NeilBrown wrote:
> On Mon, 19 Mar 2012 11:59:55 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
> 
>> Hi,
>>
>> commit 2bb77736ae5dca0a189829fbb7379d43364a9dac
>> Author: NeilBrown <neilb@suse.de>
>> Date:   Wed Jul 27 11:00:36 2011 +1000
>>
>>     md/raid10: Make use of new recovery_disabled handling
>>
>> Caused a serious regression making it impossible to recover certain o2
>> layout raid10 arrays if they get enter a double degraded state.
>>
>> If I create an array like this:
>>
>> root@monkeybay ~]# mdadm --create /dev/md25 --raid-devices=4 --chunk=512
>> --level=raid10 --layout=o2  --assume-clean  /dev/sda4 missing missing
>> /dev/sdd4
> 
> o2 places data thus:
> 
>   A  B  C  D
>   D  A  B  C
> 
> where columns are devices.
> 
> You've created an array with no place to store B.
> mdadm or really shouldn't let you do that.  That is the bug.

Here I was thinking it would rely on alien storage that would get
swapped in magically when something was missing ;)

Actually I thought raid10 here as operating more as two raid1's
concatenated.

>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md25 started.
>>
>> Then adding a spare like this:
>> [root@monkeybay ~]# mdadm -a /dev/md25 /dev/sdb4
>> mdadm: added /dev/sdb4
>>
>> The spare ends up being added into slot 4 rather than into the empty
>> slot 1 and the array never rebuilds.
> 
> How could it rebuild?  There is nowhere to get B from.
> 
> I'm surprised this every "worked"... but maybe I'm missing something.

Well it seems to be more -ENOCLUE from my side here :) Should we do
something in mdadm to prevent creating an array this way?

Cheers,
Jes
