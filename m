From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] md - 2 of 3 - Add BLKSSZGET ioctl for md driver
Date: Thu, 19 Jun 2003 11:30:44 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16113.4676.114600.293538@gargle.gargle.HOWL>
References: <E19SQog-0000Vl-00@notabene>
	<Pine.LNX.4.55L.0306182023150.25830@freak.distro.conectiva>
	<16113.60.984584.449998@gargle.gargle.HOWL>
	<Pine.LNX.4.55L.0306182055050.25903@freak.distro.conectiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marcelo Tosatti on Wednesday June 18
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 18, marcelo@conectiva.com.br wrote:
> 
> Ok, I just pusheed your stuff to bkbits.net.
> 

Thanks.
It seems that patch is now in there.  Maybe I sent it twice by
mistake.

The only missing bit is the following which I sent as a followup to on
of the NFS patches.
Thanks,
NeilBrown


diff ./net/sunrpc/svcsock.c~current~ ./net/sunrpc/svcsock.c
--- ./net/sunrpc/svcsock.c~current~	2003-06-19 11:27:05.000000000 +1000
+++ ./net/sunrpc/svcsock.c	2003-06-19 11:27:05.000000000 +1000
@@ -826,7 +826,7 @@ svc_tcp_recvfrom(struct svc_rqst *rqstp)
 			goto error;
 		svsk->sk_tcplen += len;
 		if (len < want) {
-			dprintk("svc: short recvfrom while reading record length (%d of %d)\n",
+			dprintk("svc: short recvfrom while reading record length (%d of %ld)\n",
 			        len, want);
 			svc_sock_received(svsk);
 			return -EAGAIN; /* record header not complete */
@@ -973,7 +973,7 @@ svc_tcp_init(struct svc_sock *svsk)
 				    3 * svsk->sk_server->sv_bufsz);
 
 		set_bit(SK_CHNGBUF, &svsk->sk_flags);
-		if (sk->sk_state != TCP_ESTABLISHED) 
+		if (sk->state != TCP_ESTABLISHED) 
 			set_bit(SK_CLOSE, &svsk->sk_flags);
 	}
 
