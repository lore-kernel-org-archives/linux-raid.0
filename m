From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Growing RAID10 with active XFS filesystem
Date: Mon, 8 Jan 2018 15:16:00 +0000
Message-ID: <5A538B30.4080601@youngman.org.uk>
References: <4892a03d-018c-8281-13d3-4fcc7acd2bb8@gmail.com>
 <232deaaa-7306-a01b-567f-ca5c74dc6077@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <232deaaa-7306-a01b-567f-ca5c74dc6077@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, mdraid.pkoch@dfgh.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/01/18 07:31, Guoqing Jiang wrote:
> 
> 
> On 01/06/2018 11:44 PM, mdraid.pkoch@dfgh.net wrote:
>> Dear MD-experts:
>>
>> I was under the impression that growing a RAID10 device could be done
>> with an active filesystem running on the device.
> 
> It depends on whether the specific filesystem provides related tool or
> not, eg,
> resize2fs can serve ext fs:

Sorry Guoqing, but I think you've *completely* missed the point :-(
> 
> https://raid.wiki.kernel.org/index.php/Growing#Extending_the_filesystem
> 
> And you can use xfs_growfs for your purpose.

You extend the filesystem *after* you've grown the array. The act of
growing the array has caused the filesystem to crash. That should NOT
happen - the act of growing the array should be *invisible* to the
filesystem.

In other words, one or more of the following three are true :-
1) The OP has been caught by some random act of God
2) There's a serious flaw in "mdadm --grow"
3) There's a serious flaw in xfs

Cheers,
Wol
