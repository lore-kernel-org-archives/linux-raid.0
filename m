From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: recovering from a controller failure
Date: Mon, 31 May 2010 06:55:19 +1200
Message-ID: <4C02B497.3050708@sauce.co.nz>
References: <12.2A.01646.B8CD10C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12.2A.01646.B8CD10C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Kyler Laird' <kyler-keyword-linuxraid00.a7e7f0@lairds.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leslie Rhorer wrote:

> `mdadm --assemble --assume-clean /dev/mdX /dev/<drive0>  /dev/<drive1>
> /dev/<drive2>  ...etc`

--assume-clean is not an option for assemble, the --force option is 
required.

Regards,

Richard

