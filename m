From: "jeff sacksteder" <jsacksteder@gmail.com>
Subject: Re: emergency recovery
Date: Thu, 10 Apr 2008 19:13:11 -0400
Message-ID: <51c8a7be0804101613k4d01ad02hc20ba685268a2b5a@mail.gmail.com>
References: <51c8a7be0804092329i3353055ai6216dc0e6b4066ea@mail.gmail.com>
	 <ftkclu$t6f$1@ger.gmane.org> <47FE3BB8.5010300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47FE3BB8.5010300@gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: john <john4lists@gmail.com>
Cc: Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have images of all 5 drives in my set. The set looks like this right now.

/dev/sda1 - active sync
/dev/sdb1 - faulty
/dev/sdc1 - faulty removed
/dev/sdd1 - active sync
/dev/sde1 - active sync

I am lead to believe that the way to proceed would be to
force-assemble the array with mdadm. Should I start with 4 drives, or
try to do all 5 at once? Which should I leave out?
