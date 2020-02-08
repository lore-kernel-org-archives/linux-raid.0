From: Sarah Newman <srn@prgmr.com>
Subject: Re: Was Re: Question - - - - now: issue resolved
Date: Fri, 7 Feb 2020 17:24:53 -0800
Message-ID: <1a4495cf-bd6a-7e56-46fa-87ed84d9a13c@prgmr.com>
References: <CAPpdf5-FJ0cP36pOLm40ESBOws8x5R6XbUOssFFCsY6xtb4_xw@mail.gmail.com>
 <7af58e5b-7047-a3a8-f4b2-840ea6851dea@prgmr.com>
 <CAPpdf58BTV5duFoSfdC6_07+kqQy0zgfq4=PgErJHqVeikjgBA@mail.gmail.com>
 <1faaef72-62ed-2c36-19d7-f6995691779f@prgmr.com>
 <CAPpdf58wY2G4XpNhfnHG42fHkpT6Z_EtLnLdtTaGvhRG_N5KKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf58wY2G4XpNhfnHG42fHkpT6Z_EtLnLdtTaGvhRG_N5KKA@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/7/20 4:56 PM, o1bigtenor wrote:
> On Fri, Feb 7, 2020 at 5:41 PM Sarah Newman <srn@prgmr.com> wrote:

>> I said the command dmesg, not /var/log.
>>
>> If systemd-journald is broken, or your file system is broken, you could have tons of error messages in dmesg and nothing logged to disk.
>>
> 
> Found one couplet - - - it might be applicable (please advise):
> 
> [12458.717443] EXT4-fs (md0p1): warning: maximal mount count reached,
> running e2fsck is recommended
> [12459.215097] EXT4-fs (md0p1): mounted filesystem with ordered data
> mode. Opts: (null)

What it says. You might want to run fsck at some point. Don't do it while the file system is mounted. If fsck wants to make changes, back up your data 
first.

>> just to make sure it hasn't been moved elsewhere on accident. That seems like the most likely scenario given the lack of error messages, unless no
>> messages at all have been logged due to previously mentioned issues.
>>
> Ran the suggested - - - - - well - - - - somehow I managed to drop the directory
> into a much smaller one. Dunno how that happened or any details (if someone
> cares to give method(s) and means for determining that I would be very
> grateful!) but I have now found the missing directory and its contents
> seem to be intact.
> 
> I did understand that maybe asking on the linux-raid 'exchange' might not
> have been the 'best' place to do so but this seemed quite weird and the
> directory was on a raid-array and I thought that maybe this could be a signal
> that there were more issues brewing. That seems now not to be the case.

If something in hardware or the kernel is having issues, almost always you will see error messages.

It's also better to do quick and easy checks first even if you don't have a hypothesis for what would have lead to that state.
