From: Niccolo Rigacci <niccolo@texnet.it>
Subject: Forcing a more random uuid
Date: Tue, 1 Feb 2005 18:47:39 +0100
Message-ID: <200502011847.39444.niccolo@texnet.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My previous post was answered very quickly and with an optimal solution, 
but unfortunately I have a new question...

I'm writing a script to clone a disk with several md devices.

The raid1 volumes are created on the blank disk within a very quick loop, I 
think this is the reason why I get /dev/md5, /dev/md6, /dev/md7 
and /dev/md8 all with the same UUID!

Is there a way to force a more random UUID, or do I have to provide an 
--uid option on the command line?

-- 
Niccolo Rigacci
http://www.texnet.it/
