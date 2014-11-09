From: Anton Ekermans <antone@true.co.za>
Subject: md with shared disks
Date: Sun, 09 Nov 2014 10:30:40 +0200
Message-ID: <545F2630.8090307@true.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good day raiders,
I have a question on md that I cannot find (up to date) answer to.
We use SuperMicro server with 16 shared disks on a shared backplane 
between two motherboards, running up to date CentOS7.
If I create an array on one node, the other node can detect it. I put 
GFS2 on top of the array so both system can share the filesystem, but I 
want to know if md raid is safe to be used in this way with possibly 2 
active/active nodes changing the metadata at the same time. I've 
disabled raid-check cron job on one node so they don't both resync the 
drives weekly, but I suspect there's a lot more to it than that.

If it's not possible, then alternatively some advice on strategy to have 
a large active/active shared disk/filesystem would also be welcome.

Best regards

Untitled Document

Anton Ekermans
Technical/R&D
E-mail: antone true co za
Tel: 042 293 4168 Fax: 042 293 1851
Web: www.true.co.za <http://www.true.co.za>

