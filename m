From: Antonello Piemonte <ap@cyberlab.de>
Subject: raid 1 vs raid 0+1
Date: Tue, 29 Oct 2002 13:29:23 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210291229.g9TCTcO05488@gg.cyberlab.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

I have a server wich I would like to set up with
mirroring for some data protections (against disk failure).
the machine is supposed to deal mostly with writing of
lots of small files (2kb perhaps 4kb each) to disk (well, array)
and the goal would be to be able to write at least few hundreds 
files per seconds (!).

the question is: for performance, is it better a raid 1 or a 
raid 0+1 configuration? is the above load (number of files written
per second) a realistic goal to attain with a SCSI based uniprocessor PIII 
800MHZ with ext3 file system (this I will tackle separately, perhaps
will use ext2 to increase performance) and 1 Gig of RAM? 

thanks in advance for any opinion/comment!
regards
antonello

