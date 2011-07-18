From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Mon, 18 Jul 2011 10:04:54 +0100
Message-ID: <4E23F736.30601@anonymous.org.uk>
References: <201107162140.58883.raid1@fuckaround.org> <4E226464.2030200@hardwarefreak.com> <ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org> <4E22D167.2010905@anonymous.org.uk> <20110717122230.GB2614@teal.hq.k1024.org> <4E22DABF.1020807@anonymous.org.uk> <20110717132833.GC2614@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110717132833.GC2614@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/07/2011 14:28, Iustin Pop wrote:
> On Sun, Jul 17, 2011 at 01:51:11PM +0100, John Robinson wrote:
[...]
>> doesn't work in magic sizes, so we should be using a more realistic
>> benchmarking tool like bonnie++.
>
> Honestly, I don't find bonnie++ a realistic tool. fio is a much better
> one; bonnie is quite old and inflexible.

Ah OK, yes I agree with you there, but my general point remains: dd 
might be OK for producing one very specific metric in some cases, but 
that will not give a realistic impression of real use performance, so we 
should be using a more realistic benchmarking tool.

Cheers,

John.
