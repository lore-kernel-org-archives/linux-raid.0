From: Sebastian =?ISO-8859-1?Q?Cla=DFen?=
	<Sebastian.Classen@freenet-ag.de>
Subject: MAX_CHUNK_SIZE
Date: Wed, 29 Jun 2005 16:55:31 +0200
Message-ID: <1120056931.4568.12.camel@basti79.freenet-ag.de>
Reply-To: Sebastian.Classen@freenet-ag.de
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all..

in include/linux/raid/md_k.h:
#define MAX_CHUNK_SIZE (4096*1024)

Is there any reason for this?
If I got it correctly "int" is used as dataytpe for chunk size, so
theoretically much bigger values would be possible.

Now we would like to increase the chunk size. Is it safe to increase the
value of this define? Or would there be some strange side effects?

Thanks in advace
  Sebastian.


