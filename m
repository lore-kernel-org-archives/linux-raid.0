From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Possible Bug in MD?
Date: Tue, 21 Oct 2008 07:54:29 -0500
Message-ID: <cccedfc60810210554q4ed8822eyc93f972fe2d515db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I ran into a weird problem recently.

I tried using --stop on an array that was in the process of rebuilding
(immediately following creation).

mdadm never returned.

After the array was complete, mdadm still had not returned.

An strace of the mdadm process showed, unfortunately, nothing, indicating to me
that it was stuck in the kernel somewhere.

I have no other information at this time, except that it was with the Rescue
option from the openSUSE 11.0 x86-64 DVD iso (and thus the stock kernel, mdadm
version, etc...)

-- 
Jon
