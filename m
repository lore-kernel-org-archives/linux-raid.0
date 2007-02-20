From: "=?ISO-8859-1?Q?Thomas_Lang=E5s?=" <thomas.langaas@gmail.com>
Subject: mdadm 2.6, linux 2.6.17, failed grow/reshape
Date: Tue, 20 Feb 2007 19:47:41 +0100
Message-ID: <6264d2ec0702201047s7e732a2eq6b72f54af3f4ae4d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I sent this message directly to Neil Brown first, but then I read
his homepage and found out I should have sent it here, so here goes.

I've got 5 250GB drives, 4 of which I used to create an
RAID5-md-device, after all that was done (striping and all that) I
added the last drive.  Problem is that about 30% into the process of
reshaping, my computer died, and when I've got things up on a new
system now, I can get it to start where it left off.

It says that the device (md0) is in delta 4->5, but I'm unable to get
it to restart reshaping.  Are all the data I had on the raid-device
lost?  Or is it possible to make it restart where it left off?  It
clearly knows how far it has come along, since I get some stats about
that.


In advance, thanks!


-- 
Thomas
