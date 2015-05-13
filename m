From: "Lidong Zhong" <lzhong@suse.com>
Subject: Re: [PATCH] md-cluster: avoid deadlock on MESSAGE lock
 resource
Date: Tue, 12 May 2015 20:05:21 -0600
Message-ID: <555321E1020000E1000242C6@relay2.provo.novell.com>
References: <554CB5DB.4020305@cisco.com> <554CB6B1.3030206@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <554CB6B1.3030206@cisco.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Abhijit Bhopatkar <abhopatk@cisco.com>, Goldwyn Rodrigues <RGoldwyn@suse.com>, linux-raid@vger.kernel.org
Cc: "Reese Faucette (rfaucett)" <rfaucett@cisco.com>
List-Id: linux-raid.ids

>>> On 5/8/2015 at 09:14 PM, in message <554CB6B1.3030206@cisco.com>, Abhijit
Bhopatkar <abhopatk@cisco.com> wrote: 
> On 08/05/15 6:40 pm, Abhijit Bhopatkar wrote: 
> >  
> > Every receiver has CR lock on MESSAGE while processing the message. When 
> > every receiver releases ACK lock and for some reason fails to grab EX on 
> > MESSAGE resource in time, a waiting sender could queue an EX on MESSAGE 
> > instead. Now when receiver queues its up convert request on MESSAGE it 
> > will end up in a deadlock situation. 
> >  
> > Setting NOQUEUE flag on MESSAGE lock resource while grabbing the EX on 
> > MESSAGE on sender will avoid this deadlock. If sender can not grab 
> > MESSAGE lock immediately it should retry until the lock is granted. 
> >  
> > Signed-off-by: Abhijit Bhopatkar <abhopatk@cisco.com> 
> > --- 
> > This has been minimally tested on a three node cluster.  
> >  
>  
> I have tested standard mdadm operations (create, assemble etc).  
> What more testing would you want me to do on this before its considered  
> ready? 
>  

The patch seems fine to me.  Let's see what Goldwyn's suggestion is here.

Regards,
Lidong
> Regards, 
> Abhijit 
>  
> >  drivers/md/md-cluster.c | 14 ++++++++++++-- 
> >  1 file changed, 12 insertions(+), 2 deletions(-) 
> >  
> > diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c 
> > index fcfc4b9..04ac309 100644 
> > --- a/drivers/md/md-cluster.c 
> > +++ b/drivers/md/md-cluster.c 
> > @@ -512,7 +512,10 @@ static void unlock_comm(struct md_cluster_info *cinfo) 
> >   * This function performs the actual sending of the message. This function  
> is 
> >   * usually called after performing the encompassing operation 
> >   * The function: 
> > - * 1. Grabs the message lockresource in EX mode 
> > + * 1. Grabs the message lockresource in EX. Do not queue the request if  
> not granted 
> > +      immediately. This avoids deadlock with receivers when receivers try  
> to 
> > +      upconvert CR to EX of message lockresource. The thread will retry  
> until the 
> > +      request is granted. 
> >   * 2. Copies the message to the message LVB 
> >   * 3. Downconverts message lockresource to CR 
> >   * 4. Upconverts ack lock resource from CR to EX. This forces the BAST on  
> other nodes 
> > @@ -526,12 +529,19 @@ static int __sendmsg(struct md_cluster_info *cinfo,  
> struct cluster_msg *cmsg) 
> >  	int slot = cinfo->slot_number - 1; 
> >   
> >  	cmsg->slot = cpu_to_le32(slot); 
> > -	/*get EX on Message*/ 
> > + 
> > +	/* get EX on Message with noqueue flag */ 
> > +	cinfo->message_lockres->flags |= DLM_LKF_NOQUEUE; 
> > + 
> > +retry: 
> >  	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX); 
> >  	if (error) { 
> > +		if (error == -EAGAIN) 
> > +			goto retry; 
> >  		pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", error); 
> >  		goto failed_message; 
> >  	} 
> > +	cinfo->message_lockres->flags &= ~DLM_LKF_NOQUEUE; 
> >   
> >  	memcpy(cinfo->message_lockres->lksb.sb_lvbptr, (void *)cmsg, 
> >  			sizeof(struct cluster_msg)); 
> > -- 2.1.0  
> > -- 
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
> > the body of a message to majordomo@vger.kernel.org 
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html 
> >  
>  
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
> the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 
>  
>  

