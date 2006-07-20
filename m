From: Gordon Henderson <gordon@drogon.net>
Subject: Slightly OT - Dell PERC 5 card...
Date: Thu, 20 Jul 2006 11:04:12 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0607201059090.14163@lion.drogon.net>
References: <44B6C404.1000307@vladoportos.sk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44B6C404.1000307@vladoportos.sk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


A client of mine desperately wants a Dell solution rather than a
self-build. They are looking at an external Dell box with 15 x 500GB SATA
drives in it and a Dell 1U host controller - but the connection between
them is SAS, and they want to use a (Dell) PERC5e card in the host, so
does anyone know if this is supported in JBOD mode, so I can run s/w
RAID-6 over it, rather than rely on the h/w RAID-5 on the card?

Cheers,

Gordon
