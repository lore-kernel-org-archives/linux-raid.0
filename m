From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: ERROR] scsi.c: In function 'scsi_get_serial_number_page'
Date: Wed, 19 Dec 2007 15:15:32 +0300
Message-ID: <47690B64.5070004@msgid.tls.msk.ru>
References: <476906FD.3040605@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <476906FD.3040605@bull.net>
Sender: linux-raid-owner@vger.kernel.org
To: Thierry Iceta <Thierry.Iceta@bull.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thierry Iceta wrote:
> Hi
> 
> I would like to use raidtools-1.00.3 on Rhel5 distribution
> but I got thie error

Use mdadm instead.  Raidtools is dangerous/unsafe, and is
not maintained for a long time already.

/mjt
