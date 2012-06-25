From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Stacked array data recovery
Date: Mon, 25 Jun 2012 10:31:55 +0000 (UTC)
Message-ID: <js9emr$761$1@dough.gmane.org>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>
	<4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org>
	<4FE72053.4040101@hardwarefreak.com> <4FE7E044.6040506@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 24 Jun 2012 22:51:32 -0500, Stan Hoeppner wrote:

> On 6/24/2012 9:12 AM, Stan Hoeppner wrote:
> 
>> That's premature.  If you don't have any irreplaceable data on md9 yet,
>> I'd recommend erasing all 4 EARS drives with the dd command so you have
>> a "fresh start".
> 
> Sorry Ramon, I meant the Samsungs here, not EARS.  You probably
> understood.

No, sorry I'm a bit confused.

The Samsung drives worked fine so far. I already have used the linear 
array and don't know what is written to md2 through md0.
But I could remove one Samsung disk from md2, dd it, re add it and do 
this procedure for the other three Samsungs.

What about the WD green?
I tried to dd them yesterday but when I wanted to stream a movie from the 
server it stopped. Sometimes I couldn't even ssh into the server and when 
I could the remote shell froze after a very short time.

Should I try to dd them again but one after the other so that I know 
which one makes problems?


Best regards

