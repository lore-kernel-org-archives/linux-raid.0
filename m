From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID10: how much does chunk size matter? Can partial chunks be
 written?
Date: Fri, 04 Jan 2013 18:46:20 -0600
Message-ID: <50E777DC.1060804@hardwarefreak.com>
References: <20130104175458.GA3298@hellgate> <50E75CE2.8060105@hardwarefreak.com> <20130104234113.GA14799@hellgate>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130104234113.GA14799@hellgate>
Sender: linux-raid-owner@vger.kernel.org
To: Andras Korn <korn@raidlist.elan.rulez.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/4/2013 5:41 PM, Andras Korn wrote:
> On Fri, Jan 04, 2013 at 04:51:14PM -0600, Stan Hoeppner wrote:

>> You've left out critical details:
>>
>> 1.  What filesystem are you using?
> 
> The filesystem is the "application": it's zfsonlinux. I'm putting it on
> RAID10 instead of using the disks natively because I want to encrypt it
> using LUKS, and encrypting each disk separately seemed wasteful of CPU (I
> only have 3 cores).

I just love when the other shoe drops and it turns out to be a size 13
boot... filled with lead.

Any reason why you intentionally omitted these critical details from
your initial post?

-- 
Stan

