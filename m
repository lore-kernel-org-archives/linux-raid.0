From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: some general questions on RAID
Date: Sun, 07 Jul 2013 11:51:03 -0500
Message-ID: <51D99C77.4000104@hardwarefreak.com>
References: <1372962602.8716.56.camel@heisenberg.scientia.net>  <51D5F22C.70007@turmel.org> <1373074400.10569.49.camel@fermat.scientia.net>  <51D7DADA.50200@hardwarefreak.com> <1373123715.5217.27.camel@fermat.scientia.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373123715.5217.27.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/6/2013 10:15 AM, Christoph Anton Mitterer wrote:
> On Sat, 2013-07-06 at 03:52 -0500, Stan Hoeppner wrote:
>>> Since even though you'd have one dmcrypt thread per disk now,... each of
>>> them would have to en/decrypt the "same" actual data for different
>>> devices... so while you have 4x threads... you need to do 4x
>>> en/decryption works.
>>
>> This would only be true if using n-way mirroring.
> Ah yes...
> (as you already assumed) I missed the point with striping... ;) ...
> 
> But also for RAID5/6 you shouldn't get n times the performance (when n
> is the number of disks), probably "only" about (n-1) times respectively
> (n-2) times, right?

One has nothing to do with the other.  We're discussing dmcrypt
performance here.

-- 
Stan


