From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 001 of 2] Close a small race in md thread
 deregistration
Date: Thu, 7 Apr 2005 19:14:21 -0700
Message-ID: <20050407191421.31b26d3e.akpm@osdl.org>
References: <20050408113719.27541.patches@notabene>
	<E1DJiVG-0007B6-Bd@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1DJiVG-0007B6-Bd@notabene.cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@cse.unsw.edu.au> wrote:
>
>  There is a tiny race when de-registering an MD thread, in that the
>  thread could disappear before it is set a SIGKILL, causing
>  send_sig to have problems.  
>  This is most easily closed by holding tasklist_lock between
>  enabling the thread to exit (setting ->run to NULL) and telling 
>  it to exit.

That code all seems a bit crufty to me.  Sometime it would be good to stop
using signals in-kernel and to use the kthread API for thread startup and
shutdown.

