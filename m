From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Sun, 1 Nov 2009 17:53:50 -0600
Message-ID: <cccedfc60911011553k42a27ee9u7a67b8410d781f57@mail.gmail.com>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
	<200911011241.40735.tfjellstrom@shaw.ca> <da6356c80d046663baad24dd41b6e989.squirrel@neil.brown.name>
	<200911011647.41259.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200911011647.41259.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Nov 1, 2009 at 5:47 PM, Thomas Fjellstrom <tfjellstrom@shaw.ca>=
 wrote:
> On Sun November 1 2009, NeilBrown wrote:

>> Reshaping to a new chunksize is possible with the latest mdadm and
>> =A0kernel, but I would recommend waiting for mdadm-3.1.1 and 2.6.32.
>> With the current code, a device failure during reshape followed by a=
n
>> unclean shutdown while reshape is happening can lead to unrecoverabl=
e
>> data loss. =A0Even a clean shutdown before the shape finishes in tha=
t case
>> might be a problem.

Do you know if the stable series 2.6.31.XX incorporates the appropriate=
 fixes?

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
