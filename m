From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID5 / 6 Growth
Date: Sat, 19 Dec 2009 23:39:51 +0000
Message-ID: <4B2D6447.1070406@anonymous.org.uk>
References: <88.03.04641.B353D2B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <88.03.04641.B353D2B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/12/2009 20:19, Leslie Rhorer wrote:
[...]
>> The reason why you can't mount even though repair suggests you do
>> might be because of a bug in xfsprogs/libs not a complete corruption
>> in the filesystem itself.
> 
> 	It's possible, I guess, but the diagnostics seem pretty coherent.
> Running xfs_repair in test mode finds a small but reasonable number of
> issues.

Please excuse me if this is a stupid question, but is it possible any of 
the apparent issues could be caused by the block device underneath the 
filesystem having changed size, so the filesystem's in some sense the 
wrong size now?

Cheers,

John.

