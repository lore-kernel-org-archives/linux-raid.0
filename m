From: David Greaves <david@dgreaves.com>
Subject: Re: Call for RAID-6 users
Date: Wed, 28 Jul 2004 09:36:37 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41076595.7080403@dgreaves.com>
References: <20040727021209.GA19205@jim.sh> <Pine.GSO.4.33.0407271238490.25702-100000@sweetums.bluetronic.net> <20040727172028.GA27240@jim.sh> <20040727181938.GA28181@jim.sh> <20040727184836.GA28494@jim.sh> <20040728030927.GA1625@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040728030927.GA1625@jim.sh>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Paris wrote:

>>And here's a trace showing problems even without a filesystem.
>>Writing data near the end is fatal.  This does not happen if I write
>>to the first 1G of the array.
>>    
>>
>
>Sorry, that test was bogus, and I needed to learn how to use mdadm. 
>I haven't actually managed to cause corruption on a raw device with no
>filesystem.  However, copying a single 200MB file onto Reiserfs will
>cause corruption.  It takes a lot more work (e.g. actually copying an
>installed system onto it), but XFS shows eventual corruption as well,
>so it's not specific to the filesystem type.
>
>I see no problems if I start the array with a complete set of disks;
>the corruption only happens if it starts degraded (tested with both 1
>and 2 disks missing, and with the missing disks being at both the
>beginning and the end).  This happens on Linux 2.6.3 and 2.6.7, with
>mdadm 1.5.0 and 1.4.0, with and without CONFIG_LBD.  RAID-5 works
>correctly in all tested configurations.  I have tried varying the
>number of disks in the array.
>
>  
>
FWIW a month or so ago I used mdadm + 2.6.4 and constructed a 5x250Gb 
RAID 5 array with one drive missing.
When I added the missing drive and reconstruction had finished I had fs 
corruption.

I used the reiser tools to fix it but lost an awful lot of data.

I reported it in detail here 
[http://marc.theaimsgroup.com/?l=linux-raid&m=108687793611905&w=2] and 
got zero response <shrug>

Since then it's been fine.

I don't have much faith in it though ;)

David
PS around that time there was a patch 
[http://marc.theaimsgroup.com/?l=linux-raid&m=108635099921570&w=2]
for a bug in the RAID5 resync code.
it was only for the raid5.c
It doesn't look raid5 algorithm specific ... :)
