From: Christian Kivalo <valo@valo.at>
Subject: Re: strange nr. of devices in array
Date: Sat, 21 Feb 2004 19:35:08 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040221193508.000058a4@valo.lan.valo.at>
References: <20040220214811.0000192c@valo.lan.valo.at>
	<40372285.7060002@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40372285.7060002@web.de>
To: Norman Schmidt <norman.schmidt@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 21 Feb 2004 10:19:01 +0100, Norman Schmidt
<norman.schmidt@web.de> wrote:
 
> > i'm using mdadm version 0.7.2, i think that is pretty old. i will
> > upgrade to a more recent version and recreate the array.
> > 
> > still i would like to know if i encountered a bug or if thats some
> > other problem. this mdadm version is the one from debian woody
> > (stable).
> > 
> > 
> > thanks in advance
> > christian
> 
> Yes, that is a bug in the (very old) 0.7.2 of Debian. Additionally, 
> these old versions cannot handle spare devices (after each assemble,
> you hae to add them manually). Use at least mdadm 1.4.0, better the
> newest (I believe 1.5.0). You do not need to recreate the array,
> simply stop it and (re-)assemble it after you have the new mdadm in
> place - and the bug and the wrong output is gone.
> 
> Had the same problem (that with the spare device) with SuSE 8.2 and 
> Debian Woody...
> 

hi!

thanks for that information, i will upgrade to the newest mdadm and try
again.

thanks
christian


> Bye, Norman.
> 
> -- 
> 
> Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
> Dipl.-Chem.             Friedrich-Alexander-Universitaet
> schmidt@naa.net         Erlangen-Nuernberg
>                          IT-Systembetreuer Physikalische Chemie
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
