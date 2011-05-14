From: David Brown <david.brown@hesbynett.no>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 15:00:02 +0200
Message-ID: <iqluci$duh$2@dough.gmane.org>
References: <20110513202900.GA1926@apartia.fr>	<20110514073347.15dae0b8@notabene.brown>	<20110514082159.GA306@apartia.fr>	<20110514215821.58f49455@notabene.brown> <20110514180627.23f75ba0@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110514180627.23f75ba0@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/05/11 14:06, Roman Mamedov wrote:
> On Sat, 14 May 2011 21:58:21 +1000
> NeilBrown<neilb@suse.de>  wrote:
>
>> If you don't have ext3, then you probably need to backup and restore - I
>> don't think other filesystems support shrinking, but I could be wrong.
>
> Well, ext4 does support shrinking as well.
>
> And btrfs, it has both online shrinking and growing.
>
> XFS, JFS can only be grown, not shrinked.
>

reiserfs3 can also be shrunk - you can even do it while mounted, if you 
want.  (resize2fs will grow a mounted extX system, but it must be 
unmounted for a shrink.)


