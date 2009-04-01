From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Wed, 01 Apr 2009 13:36:58 -0700
Message-ID: <49D3D06A.50800@zytor.com>
References: <87ljr4hsk9.fsf@frosties.localdomain> <20090318121825.GL32416@skl-net.de> <49D39169.2050705@zytor.com> <20090401174729.GW17185@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090401174729.GW17185@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Noll wrote:
> 
> Out of curiosity, why is any special-casing needed for the 3-disk case?
> 

As I remember it, at least one of the optimized calculation loops didn't 
like the case of only one data drive.

	-hpa
