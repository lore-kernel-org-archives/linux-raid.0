From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 12:36:24 +0100
Message-ID: <58FC91B8.5090603@youngman.org.uk>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
 <20170423104606.GA4603@metamorpher.de>
 <754209bb-9990-2a36-2233-d7d1273c8e37@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <754209bb-9990-2a36-2233-d7d1273c8e37@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/04/17 12:12, Patrik Dahlström wrote:
> At least I now know in what order that I should assemble my original 5
> drives:
> sda, sdb, sdd, sdc, sde
> It would only be logical for the new drive (sdf) to be last in that list.

And, as the raid wiki tells you, download lspci and run that. That will
hopefully tell us a lot about what's left of the various headers on your
disks.

My worry is that Permute_Array will have tried a whole bunch of "mdadm
--create" variants and totally trashed your original headers.

Cheers,
Wol
