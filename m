From: jshankar <jshankar@CS.ColoState.EDU>
Subject: chunk size.
Date: Sat, 18 Oct 2003 15:54:40 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F950B86@webmail.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

For raid devices, i have observed that if size of bytes written is greater 
than the chunk size the read,write performance decreases.For size lesser than 
the chunk size the performance improves.

Please let me know your opinion.


Thanks
Jay

