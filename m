From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Rebuild events while scrubbing - problems or just informational?
Date: Wed, 11 Dec 2013 08:11:44 +0100
Message-ID: <52A81030.1040101@gmail.com>
References: <CAK2H+ed3vEJVF8To8FWD_Ltj7jGKgrBAvz-Aum4viR=VZE+gww@mail.gmail.com>	<20131210085225.GA441@cthulhu.home.robinhill.me.uk>	<52A7476A.9060307@gmail.com> <20131211123826.0942ea22@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131211123826.0942ea22@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/11/2013 02:38 AM, NeilBrown wrote:
> I guess that doesn't explicitly say it is normal, but that is the intent :-)
> 
> They should be generated from recovery, resync, reshape, check, repair and
> anything else that might be added which processes the whole array like that.
> I guess "Rebuild" isn't a very generic word.. but
>    "StuffStarted"
>    "Stuff20"
>    "StuffFinished"
> probably wouldn't go down well either.

Thanks Neil.

What I meant is that there is no definition of "reconstruction" in the
manpage, so that it is not formally clear whether check is or is not a
form of reconstruction.

I'll try and submit a manpage patch, but hopefully you'll accept it by
private email because I'm still banned from posting to any list hosted
by vger using my regular email accounts. My name is Jan Ceuleers, not
Can Jeuleers.

Jan
