From: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: SATA start unit command?
Date: Mon, 18 Mar 2013 00:30:50 +0100
Message-ID: <103777438.20130318003050@oudeis.org>
Reply-To: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

for some reasons I need to keep power consumption at startup as low as
possible. since the server is booting from SSD, it is possible to send
a "start unit" (or similar) command to all SATA drives early in the
init process.

as far as I've searchengined, the drives and the SATA controller need
to support this feature. but my assumption is that when the drives are
not needed at startup (since they would be started by the OS), the
controller won't need to support "start unit".  what is your
experience on this matter? 

drives in question are WD Green 3TB drives (WDC WD30EZRX-00DC0B0), the
controllers at hand are a promise SATA 300 TX4 (don't laugh ;-) ) and
a supermicro AOC-SAT2-MV8.

tnx.

