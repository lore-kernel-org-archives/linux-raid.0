From: Federico <undicizeri@gmail.com>
Subject: Re: prefered way to update mdadm/mdadm.conf
Date: Fri, 17 Apr 2009 23:30:26 +0200
Message-ID: <26c008d70904171430m19340bfew51764775f125e4df@mail.gmail.com>
References: <001b01c9bfa1$c5bd30c0$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001b01c9bfa1$c5bd30c0$0a00a8c0@vorg>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm using mdadm --examine --scan >> /etc/mdadm/mdadm.conf because with
--detail mdadm report also the  metadata=  which produces warning
during the the boot ("warning: metadata=00.90 not recognize" or
something like that).
