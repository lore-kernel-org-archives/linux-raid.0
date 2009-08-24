From: Info@quantum-sci.net
Subject: Re: Help
Date: Mon, 24 Aug 2009 16:08:19 -0700
Message-ID: <200908241608.19739.Info@quantum-sci.net>
References: <200908210627.06241.Info@quantum-sci.net> <B0F2EBD236974CA9878F0752EACFC835@m5> <200908230631.46865.Info@quantum-sci.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200908230631.46865.Info@quantum-sci.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The sync has finally finished, but something's wrong with the first partition set;  Only sda1 is a member of md0.  In dmesg I find:
[    4.756365] md: kicking non-fresh sdb1 from array!

Huh?  If it's not fresh, why doesn't it sync it?  What should I do about this?  How did it happen on a new array?


