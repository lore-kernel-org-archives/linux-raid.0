From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: RFC: use TRIM data from filesystems to speed up array rebuild?
Date: Tue, 04 Sep 2012 14:28:59 -0600
Message-ID: <5046648B.8010905@genband.com>
References: <50464322.3010509@genband.com> <20120905062113.05e4f0f4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120905062113.05e4f0f4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/04/2012 02:21 PM, NeilBrown wrote:
> On Tue, 04 Sep 2012 12:06:26 -0600 Chris Friesen<chris.friesen@genband.com>
> wrote:
>> Hi,
>>
>> I'm not really a filesystem guy so this may be a really dumb question.
>>
>> We currently have an issue where we have a ~1TB RAID1 array that is
>> mostly given over to LVM.  If we swap one of the disks it will rebuild
>> everything, even though we may only be using a small fraction of the space.
>>
>> This got me thinking.  Has anyone given thought to using the TRIM
>> information from filesystems to allow the RAID code to maintain a
>> bitmask of used disk blocks and only sync the ones that are actually used?
>>
>> Presumably this bitmask would itself need to be stored on the disk.
> Something like this?
>    http://neil.brown.name/blog/20110216044002#5

Something like that would indeed cover the use-case that triggered this.

Chris
