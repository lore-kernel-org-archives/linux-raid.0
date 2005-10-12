From: Harry Mangalam <hjm@tacgi.com>
Subject: safe to test SATA array by pulling cables?
Date: Wed, 12 Oct 2005 10:19:01 -0700
Message-ID: <200510121019.01136.hjm@tacgi.com>
References: <42da427a.2e075618.7fea.2c30@mx.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42da427a.2e075618.7fea.2c30@mx.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've read conflicting views on whether it's safe to pull either or both the 
SATA data cable or power cable from a disk in an array (when they are NOT in 
a hotswap cage) to test whether things works as expected during a real life 
disk failure.

Is there a consensus on this?  Theoretically either should be handled by the 
controller (a 3ware 9500s) since this is a real life possibility, but will 
either event cause damage to the disk?  I'd suspect that removal of the data 
cable would simulate a disk loss with less physical trauma to the disk in 
question.


-- 
Cheers, Harry
Harry J Mangalam - 949 856 2847 (vox; email for fax) - hjm@tacgi.com 
            <<plain text preferred>>
