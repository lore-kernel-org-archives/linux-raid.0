From: "Majed B." <majedb@gmail.com>
Subject: Re: Adaptec 1430SA
Date: Wed, 9 Sep 2009 11:58:18 +0300
Message-ID: <70ed7c3e0909090158g2df91934t7e6c964d5bd2215f@mail.gmail.com>
References: <70ed7c3e0909081513h5affac5at2ce313d02bb01eba@mail.gmail.com>
	<332340.55866.qm@web51306.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <332340.55866.qm@web51306.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon, I don't know what your motherboard is nor what your PCI bus
version is, so you may want to take a look here:
http://en.wikipedia.org/wiki/Conventional_PCI

At that link you can see the PCI bus speeds for the different versions
and calculate how much you'll get out of your disks.

I suggest you run a quick benchmark of how quick your disks can
read/write (using hdparm -tT or dd). If you're not familiar with
either, check this:
http://mbhtech.blogspot.com/2009/09/software-raid-vs-lvm-quick-speed-test_08.html

When benchmarking the disk, make sure it's connected to a native SATA
port, not to a PCI card, to make sure that the numbers you're getting
are not crippled by the PCI card or so.

P.S.: Last year I bought 2 dual SATA port cards that were cheap from
Amazon, hoping to expand my storage easily. Those two required
flashing their controller with newer firmware and because the
manufacturer's website was so vague, I ended up bricking the first
card (flashed the wrong BIOS/firmware). And even when the 2nd card
detected the 1TB disks, it was utter crap; the cables were mostly
loose due to low-quality connectors.

So because BackBlaze is using the cards they said they use, I'm sure
at least those have good connectors and firmware!

On Wed, Sep 9, 2009 at 10:44 AM, Jon Hardcastle<jd_hardcastle@yahoo.com> wrote:
> --- On Tue, 8/9/09, Majed B. <majedb@gmail.com> wrote:
>
>> From: Majed B. <majedb@gmail.com>
>> Subject: Re: Adaptec 1430SA
>> To: "John Robinson" <john.robinson@anonymous.org.uk>
>> Cc: Jon@ehardcastle.com, linux-raid@vger.kernel.org
>> Date: Tuesday, 8 September, 2009, 11:13 PM
>> Check this link out:
>> http://blog.backblaze.com/2009/09/01/petabytes-on-a-budget-how-to-build-cheap-cloud-storage/
>>
>> AT the end, they have a list of components, cheap ones. One
>> is a
>> 2-port sata card and another is a 4-port sata card. You
>> might find
>> them appealing to your usage.
>
> Are you referring to the Addonics ADSA4R5? Thanks for the heads up! Is PCI straight up got the throughput for 4 devices? I have a 2 port cheapy PCI via card Sata 1 and it has turned out to be abit of a mare...
>
> Whilst I have a skilled audience :) Do you have any experience with port multiplier?
-- 
       Majed B.
