From: mike_rothon <mfr@supanet.com>
Subject: Re: hostRAID, AIC-7901, disable? - FIXED
Date: Sun, 20 Mar 2005 12:29:31 +0000
Message-ID: <d1jq8n$p62$1@sea.gmane.org>
References: <cpkem3$70s$1@sea.gmane.org>      <bbfa52890412131309234b2d09@mail.gmail.com>       <cpl0tm$4sp$1@sea.gmane.org>      <1103132961.3629.41.camel@compaq-rhel4.xsintricity.com> <32897.194.153.181.92.1103661695.squirrel@mail.valli.org> <d1bh6i$vfk$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <d1bh6i$vfk$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I will prefix this message by stating that I am not a Linux expert in any way! 
This is especially true of Kernel and module matters.

Finally, however and after many hours of trying I believe I have found a good 
fix to run u320raid on a SuSE linux box!

Tucked away on the Adaptec web site is an IBM download for SLES9, which is 
claims to be "released". What isn't mentioned is that this driver **seems to 
be** compatible with SuSE Linux 9.1.

You can find an image of the driver update disk here:

http://www.adaptec.com/ibm/downloads/released_serveRAID7e_index.html

Instructions to make the disk are in the adaptec user guide.

If you haven't had experience of driver update disks before (as I hadn't) there 
is a good article here:

http://portal.suse.com/sdb/en/2001/12/hmeyer_driver_update.html

Importantly however for SuSE to find the driver you need to rename the directory 
from i386-SLES3 to i386-9.1 and the subdirectories in the update.tar.gz file to 
match your kernel version. CAVEAT - this is slightly risky - as it leads to a 
"tainted" kernel.

With the stock kernel on the 9.1 CD's it appears the driver is compatible 
although there is a tainted message during boot.

Feedback is welcomed, particular about the advisability of this solution.

Mike Rothon.
Certisa Ltd.
www.certisa.com

