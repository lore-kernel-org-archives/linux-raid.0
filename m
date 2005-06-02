From: Carlos Knowlton <cknowlton@update.fsix.com>
Subject: Is there a drive error "retry" parameter?
Date: Thu, 02 Jun 2005 10:23:04 -0500
Message-ID: <429F2458.6070404@update.fsix.com>
References: <200505021224.35396.mlaks@verizon.net>
Reply-To: cknowlton@science.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200505021224.35396.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I want to understand exactly what is going on in the Software RAID 5 
code when a drive is marked "dirty", and booted from the array.  Based 
on what I've read so far, it seems that this happens any time the RAID 
software runs into a read or write error that might have been corrected 
by fsck (if it had been there first).  Is this true?

Is there a "retry" parameter that can be set in the kernel parameters, 
or else in the code itself to prolong the existence of a drive in an 
array before it is considered dirty? 

If so, I would like to increase it in my environment, because it seems 
like I'm losing drives in my array that are often still quite stable.


Thanks!
Carlos Knowlton
