From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: HBA Adaptor advice
Date: Sat, 21 May 2011 05:23:29 +0800
Message-ID: <4DD6DBD1.3050807@fnarfbargle.com>
References: <4DD50C89.8060006@wildgooses.com> <4DD5867A.2090102@fnarfbargle.com> <BANLkTimBX-oCoOT2+GSSzAbs0U_MNv2Mpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimBX-oCoOT2+GSSzAbs0U_MNv2Mpw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/05/11 04:58, Tobias McNulty wrote:
>
> * SYBA SD-PEX40031 (Pericom PI7C9X111 + Silicone Image Sil3124
> chipset) - lots of errors during heavy I/O such as resyc'ing

Oh dear.. Gee, another item of useless anecdotal evidence directly attributable to cheaply 
manufactured cards from a third world country and no direct correlation to a flaky chipset design.

> * 3ware 9650SE-8LPML-Sgl - I thought money would solve the problem,
> but I didn't realize that you can't use an expensive RAID card to
> access existing data on the disk

Ahh..

> * Supermicro AOC-Saslp-MV8 - I thought it would be a perfect match
> given my Supermicro motherboard, but also gave me lots of errors
> during heavy I/O and this experience seems to be confirmed by other
> users in this thread

Oh dear.. Yes, the mvsas driver has been noted to be somewhat problematic still.

I hope you're not a betting man. 3 for 3 is not a great record thus far. On the up-side the 7042's 
have been as solid as a rock.. and _fast_ for the last couple of years. Marvell worked with Mark 
Lord and the result was a workable version of the sata_mv driver. Shame they don't do the same with 
the mvsas code.

Additionally, I migrated two arrays from the Marvell7042 controllers onto the LSI based "IBM" 
controllers configured up as JBOD and they just worked. No initialisation or reconfiguration 
required at all.

Brad
