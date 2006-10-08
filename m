From: Henrik Holst <henrik.holst@idgmail.se>
Subject: Re: mdadm segfault
Date: Sun, 08 Oct 2006 15:29:21 +0200
Message-ID: <4528FD31.6080105@idgmail.se>
References: <20061008121442.GA27570@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061008121442.GA27570@janus>
Sender: linux-raid-owner@vger.kernel.org
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Frank van Maarseveen wrote:
> Maybe it's fixed already but just in case... trying to assemble an array
> by UUID without any mdadm.conf segfaulted, e.g.:
> 
> 	mdadm -A --uuid=d764947c:875b3b25:d10330b1:eec6e325 /dev/md10 -c partitions
> 

You probably want to include version of mdadm as well as your kernel
version.

Please post your /proc/partitions file as well.

--
Henrik Holst
