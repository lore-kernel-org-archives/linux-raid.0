From: Martin Wilck <mwilck@arcor.de>
Subject: Re: MD array keeps resyncing after rebooting
Date: Thu, 25 Jul 2013 21:06:14 +0200
Message-ID: <51F17726.8020603@arcor.de>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>	<CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>	<51EED0DA.3020901@arcor.de>	<51EED102.4020503@arcor.de>	<CAC9WiBgN1-HBEgqwo7CWor=nihCYUcOrYKhGxYTgbC-d4a7_-g@mail.gmail.com>	<51EEF3D3.7020305@arcor.de>	<CAC9WiBgrjrPRcHa5kh8TUfqN0rBBFC4M0_8iDkU3O0SOFgFW5g@mail.gmail.com> <CAC9WiBjQz6MJxBuw+cLWFZ-vOsdbYYSKdE575emH_AG5EmnGdw@mail.gmail.com> <51F1754B.5000905@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F1754B.5000905@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/25/2013 08:58 PM, Martin Wilck wrote:

> Thinking about it - you did some coding of your own to start mdmon in
> the initrd, right? Do you also make sure that mdadm -Ss is called after
> umounting the file systems, but before shutdown? If not, an inconsistent
> state might result.

I forgot - mdadm -Ss needs to be run after unmounting file systems,
killing logical volumes, etc, but before killing mdmon.

This can be bit tricky.
However if your distro supports md with IMSM, the code should be in place.

Martin
