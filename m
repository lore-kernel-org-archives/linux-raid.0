From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: question about the best suited RAID level/layout
Date: Sun, 07 Jul 2013 14:36:10 +0800
Message-ID: <51D90C5A.20308@fnarfbargle.com>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>  <51D5EC8A.40509@turmel.org> <1372978687.5249.52.camel@fermat.scientia.net>  <51D61C58.2020207@fnarfbargle.com>  <1373070976.5395.26.camel@fermat.scientia.net>  <51D7AB24.1030003@fnarfbargle.com> <1373122142.5217.7.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373122142.5217.7.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/07/13 22:49, Christoph Anton Mitterer wrote:
> On Sat, 2013-07-06 at 13:29 +0800, Brad Campbell wrote:
>> A messy process to be sure, but no risk of data loss that way.
> Sure... but that might not always be possible at all... imagine you're
> hit by a power outage (okay one could argue, that one must run an
> UPS)... or kernel panic...

If you are not running a UPS, you are not actually serious about your 
data integrity. I don't care if its an APC BackUPS with 5 minutes 
hold-up, you need to be able to shut down cleanly.

> Or people being very paranoid (like me) probably won't let their
> dm-crypt encrypted devices run when being away (freeze attacks against
> the RAM)...

I use dm-crypt too, but there are far easier ways to get access to my 
data than performing a cold attack against my server, so I spend my 
effort against those risks instead.

I guess if your risk assessment states that is a risk worthy of 
mitigating then you have to do what you have to do. Paranoia for 
paranoia's sake can be fun if you don't have anything else to do, but 
unless there is a real (not perceived) risk, then you just balance your 
treatments against that.

> Anyway... I guess this goes off topic ;)
>

Far, far, far...

> But I see that you have not real point *against* running devices from
> different vendors either. Correct me if I'm wrong ;)

Nope. Not wrong at all. That'd be my preference if practical. On the 
other hand, my 10 x WD 2TB green drive RAID-6 is about the worst 
potential time bomb, but then it's all backed up and restore-able if the 
worst should happen. Risk is "very likely", consequence is minimal.

My work data on the other hand is on a RAID-10 of SAS drives with 60 
days of rotating off site & off line backups. Risk is "unlikely", but 
consequence is massive.

We had a TV advertising campaign targeting speeding here here for a few 
years. To paraphrase :  "Choose your speed(risk), choose your 
consequences...".



