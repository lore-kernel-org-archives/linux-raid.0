From: "John Stoffel" <john@stoffel.org>
Subject: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 10:34:27 -0400
Message-ID: <18200.49267.763509.924873@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


So, 

Is it time to start thinking about deprecating the old 0.9, 1.0 and
1.1 formats to just standardize on the 1.2 format?  What are the
issues surrounding this?

It's certainly easy enough to change mdadm to default to the 1.2
format and to require a --force switch to  allow use of the older
formats.

I keep seeing that we support these old formats, and it's never been
clear to me why we have four different ones available?  Why can't we
start defining the canonical format for Linux RAID metadata?

Thanks,
John
john@stoffel.org
