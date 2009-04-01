From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Adding more drives/saturating the bandwidth
Date: Wed, 01 Apr 2009 17:59:38 +0200
Message-ID: <87skks9xg5.fsf@frosties.localdomain>
References: <771992.67269.qm@web51307.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <771992.67269.qm@web51307.mail.re2.yahoo.com> (Jon Hardcastle's
	message of "Wed, 1 Apr 2009 01:56:14 -0700 (PDT)")
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Hardcastle <jd_hardcastle@yahoo.com> writes:

> --- On Tue, 31/3/09, Goswin von Brederlow <goswin-v-b@web.de> wrote:
>> Just see if you can get a decent bandwidth from each disk:
>> 
>> for i in /dev/sd?; do dd if=$i of=/dev/null bs=1M
>> count=10240 & done
>> iostat -k 10
>> 
>> 
>> Halving the bus speed gives you a reasonable low
>> expectation of how
>> much data you should be able to pull of the disks. If your
>> disks can't
>> even fill half the bus bandwidth you certainly can cope
>> with more
>> disks or something is seriously wrong.
>> 
>> MfG
>>         Goswin

Perfectly save. Just don't do it the other way around:

!!!WARNING WRITE TEST!!!

for i in /dev/sd?; do dd if=/dev/zero of=$i bs=1M count=10240 & done
iostat -k 10

MfG
        Goswin
