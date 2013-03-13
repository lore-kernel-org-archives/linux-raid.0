From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Help with two momentarily failed drives out of a 4x3TB Raid 5
Date: Wed, 13 Mar 2013 05:13:00 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1303130512310.378@uplift.swm.pp.se>
References: <CAAnFQG8Ca7fkr-vboobr_qmRMTn38U9QP5hiT-9Ps0BqWcunzw@mail.gmail.com> <29375201.0.1362994874930.JavaMail.root@zimbra> <CAAnFQG__hwROJG1mE9BAaoapUDXTos+52udEp0yc6SfQz==DKA@mail.gmail.com> <CADNH=7E0788eV7zZKbWao4n1+WEMCcaX9sp7MkBgsCKrLmocSA@mail.gmail.com>
 <CAAnFQG_mJEAa=nPTOm0n7pjX7g8saLRTEtm-FDhP5+MYOOsH5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAnFQG_mJEAa=nPTOm0n7pjX7g8saLRTEtm-FDhP5+MYOOsH5Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Javier Marcet <jmarcet@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 12 Mar 2013, Javier Marcet wrote:

> I have filed the RMAs and ordered a new disk so that I can at least copy 
> some of the data. Yet I have been thinking I could clone the drive which 
> is still part of the array and has one bad sector over the new one and 
> try to assemble the raid with the clone.
>
> Could that work?

Yes, to use dd_rescue or gddrescue for this purpose is very common.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
