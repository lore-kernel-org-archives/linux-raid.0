From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid6 failed due to loss of connection
Date: Sat, 20 Nov 2010 06:37:44 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1011200635460.1154@uplift.swm.pp.se>
References: <4CE66E99.6050806@smarteye.se>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1880971805-1290231408=:1154"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE66E99.6050806@smarteye.se>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Bj=F6rn_Englund?= <be@smarteye.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1880971805-1290231408=:1154
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 19 Nov 2010, Björn Englund wrote:

> Should I try mdadm -A -f /dev/md12 or do I need to run a create command 
> to get the array up and running?

Doing a create is always the last measure to try. Forcing re-assembly is a 
gazillion times safer because you can't get the data-disks in wrong order.

Make sure you have the latest mdadm (3.1.4 I believe) and force-assemble 
the array and see if that works.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1880971805-1290231408=:1154--
