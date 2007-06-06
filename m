From: Hubert Verstraete <hubskml@free.fr>
Subject: bug report on mdadm --export
Date: Wed, 06 Jun 2007 15:25:05 +0200
Message-ID: <4666B5B1.10908@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

a quick mail to report a bug. The option -Y is not recognized by mdadm 
2.6.2. Acccording to the man page, this is an alias to --export.

By the way, are there any plan to make the --export command work with 
some other commands like --examine ?

Hubert Verstraete
