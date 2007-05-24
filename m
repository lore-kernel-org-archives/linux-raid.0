From: Colin McCabe <Colin.P.McCabe@gmail.com>
Subject: Re: Fwd: Identify SATA Disks
Date: Thu, 24 May 2007 12:06:51 -0400
Message-ID: <4655B81B.4040307@gmail.com>
References: <8c4e120705230023v71a2ffa3p182f1e02ccb9cd54@mail.gmail.com> <8c4e120705231629q727718f2yb0704ff33b7012c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8c4e120705231629q727718f2yb0704ff33b7012c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

lewis shobbrook wrote:
> Also I've not had much joy in attempting to "hotswap" SATA on a live 
> system.
> Can anyone attest to successful hotswap (or blanket rule out as
> doesn't work) using std on board SATA controllers,  cf dedicated raid
> card, or suggest further reading?
> I've spent considerable time here and there in recent years trying to
> find some decent info on this...

Hotswap works fine for me. My disks are both: FUJITSU MHV2060BH
The serial ata controller is recognized as an ICH6.

Make sure that your BIOS settings are in serial ATA mode, not legacy 
emulation mode. Also, you should be using the libata driver if you want 
hotswap.

Colin

