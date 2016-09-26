From: Phil Turmel <philip@turmel.org>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Mon, 26 Sep 2016 17:15:05 -0400
Message-ID: <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
 <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/26/2016 03:47 PM, Benjammin2068 wrote:
> Well that instills fear and doubt...
> 
> the mismatch_cnt was 8.
> 
> I did a repair and then a check and now it's 10704....
> 
> :(

Danger Will Robinson!

Seriously.  You very likely have a hardware problem corrupting your
data.  Do you have ECC RAM, and if not, when was the last time you did
an exhaustive memtest?

Recheck all of your data cables and if using an add-on controller, check
for a secure install in the PCIe slot.

Phil

