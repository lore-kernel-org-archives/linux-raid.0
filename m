From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Good hardware for mdadm
Date: Sat, 30 Aug 2014 23:56:28 +0800
Message-ID: <5401F42C.7050805@fnarfbargle.com>
References: <ltqnvm$80o$1@ger.gmane.org> <CAH3kUhH=ZdfRtMw+FiRz4c7qkt8UgbHuoTKiUKyq5Uu9AxHBsQ@mail.gmail.com> <ltqscm$qp5$1@ger.gmane.org> <CAAMCDedo1N1RybUQ4=fd=R9TDtY=TF-aYomYmxA2d250fmgjbA@mail.gmail.com> <lts2cg$crt$1@ger.gmane.org> <CAAMCDeePxPc3VryFibYBYkstZXU42kxAZQTFcsSbY6e-uzUfLA@mail.gmail.com> <lts9gt$6d3$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <lts9gt$6d3$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Paul van der Vlis <paul@vandervlis.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/08/14 18:37, Paul van der Vlis wrote:
> op 30-08-14 11:53, Roger Heflin schreef:
>> That means you need an external config tool  (serial, ilo or IMM that
>> allows remote console access), I rarely go into the data center that
>> all of the hw I run is in, and because of the remote console access
>> can fix all but truly broken hw without having hands in the DC).
>
> That's a way to repear something what's broken. Not a more redundant
> solution I was looking for. But you are right, it helps a lot. I use
> IPMI for remote console. And on some machines a serial console.
>

You do realise that the IPMI is also not redundant and uses exactly the 
same memory type that the DOM offers (which you pointed out was not 
redundant).

Disks die. Anything else is a hands on fix. If you want more reliable 
you go dual-redundant (possibly with a hot standby).

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
