From: Sarah Newman <srn@prgmr.com>
Subject: Re: mdadm bad blocks list
Date: Mon, 1 Feb 2016 18:40:43 -0800
Message-ID: <56B0172B.8020808@prgmr.com>
References: <56A9102D.4030304@prgmr.com>
 <87twly1jc7.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87twly1jc7.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/27/2016 07:19 PM, NeilBrown wrote:
> On Thu, Jan 28 2016, Sarah Newman wrote:
> 
>> Kernel: CentOS 6 Xen4CentOS 3.18.21-17
>> mdadm: CentOS 6 v3.3.2
>>
>> With the above behavior, I consider the bad blocks list to be actively harmful. If it's expected behavior in the current version, please consider
>> disabling the bad blocks list by default.
> 
> You can do this yourself by putting
> 
>   CREATE bbl=no
> 
> in /etc/mdadm.conf.  That doesn't help others though.

FYI, I tried adding that line and if it is present when trying to add to an array that currently has a bad blocks list, I get the error message

md: sdi1 does not have a valid v1.0 superblock, not importing!

Is this expected?

Thanks, Sarah

