From: "J. David Beutel" <jdb@getsu.com>
Subject: RAID1 robust read and read/write correct patch
Date: Wed, 23 Feb 2005 01:01:33 -1000
Message-ID: <421C628D.8080908@getsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'd like to try this patch 
http://marc.theaimsgroup.com/?l=linux-raid&m=110704868115609&w=2 with 
EVMS BBR.

Has anyone tried it on 2.6.10 (with FC2 1.9 and EVMS patches)?  Has 
anyone tried the rewrite part at all?  I don't know md or the kernel or 
this patch, but the following lines of the patch seem suspicious to me.  
Should it set R1BIO_ReadRewrite instead?  That bit gets tested later, 
whereas it seems like R1BIO_ReadRetry is never tested and 
R1BIO_ReadRewrite is never set.

+#ifdef DO_ADD_READ_WRITE_CORRECT
+	        else    /* tell next time we're here that we're a retry */
+	                set_bit(R1BIO_ReadRetry, &r1_bio->state);
+#endif /* DO_ADD_READ_WRITE_CORRECT */


Cheers,
11011011
