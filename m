From: jeffs_linux@123mail.org
Subject: Re: Bug or not?  Same array reports different/transformed UUID
 depending on check-method used.
Date: Tue, 21 Jun 2011 05:50:49 -0700
Message-ID: <1308660649.16501.1465562409@webmail.messagingengine.com>
References: <1308328189.28028.1464311105@webmail.messagingengine.com>
 <20110621054258.GA22391@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110621054258.GA22391@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 21 Jun 2011 07:42 +0200, "Luca Berra" <bluca@comedia.it> wrote:
> The map_file, on the contrary, is always read and written as 4 32bit
> values in host endian order, so on x86 machines you will find it
> swapped.
> 
> Summary: the mapfile is for mdadm internal use only, use mdadm commands
> (--detail, --examine) to obtain data.
> 
> (*) http://en.wikipedia.org/wiki/Endianness

Ok.

How might that explain that one array IS 'swapped', and the other is
not?  They're both on the same machine?

jeff
