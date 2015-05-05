From: "Lidong Zhong" <lzhong@suse.com>
Subject: Re: Potential race in dlm based messaging md-cluster.c
Date: Tue, 05 May 2015 03:22:52 -0600
Message-ID: <5548FC6C020000E100022FA0@relay2.provo.novell.com>
References: <CAE3Hb8oss1JZ2u7g7OQQgrEtgQ1vbQou04isiS6eEqbS=uzbhw@mail.gmail.com>
 <CAE3Hb8qNczD30RrcHFYCR90Jf9QFD-XH=x89MAu4Dpmm80se0A@mail.gmail.com>
 <554251EA.3000807@suse.com>
 <CAE3Hb8pJ=0MB6EX5jVch28gj-gnf0Mp1wyzxBfWjzLf=SuV4sQ@mail.gmail.com>
 <5542763C.90202@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5542763C.90202@cisco.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Abhijit Bhopatkar <abhopatk@cisco.com>, Goldwyn Rodrigues <RGoldwyn@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>> On 5/1/2015 at 02:36 AM, in message <5542763C.90202@cisco.com>, Abhijit
Bhopatkar <abhopatk@cisco.com> wrote: 
> There is a possibility of a receiver losing out on messages in certain  
> corner conditions. One of the buggy case is if there is are two sender  
> ready with messages to be sent. Sender 1 initially gets the TOKEN lock  
> and proceeds. 
> After initial processing the sender of message 1 _will_ release TOKEN as  
> soon as receiver releases ACK, it does not wait till ACK CR is  
> re-acquired by receiver. 
>  
> To illustrate the problem consider timeline for two senders and one  
> receiver (we will ignore receive part for Sender2 node) 
>  
> Sender1              Sender2                         Receiver 
> Get EX on TOKEN       Get EX on TOKEN 
> <Granted>                    <Wait till granted> 
>  
> Get EX on MSG 
> write LVB 
> down MSG to CR 
> Get EX of ACK 
> <wait till granted>                                                      
>       BAST for ACK 
>                                                              Get CR on MSG 
>                      read LVB 
>                      process 
>                      release ACK 
> AST for ACK 
> down ACK to CR 
> release MSG 
> release TOKEN 
>                     <granted> 
>                     Get EX on MSG 

I am afraid this corner case could not be achieved ever. Sender2 will be blocked on getting 
EX lock on MSG resource until the receivers release the lock. The receivers' request on 
upconverting CR to EX on MSG should be put into the convert queue before Sender2's 
request being put into the wait queue, because sender2 has to wait until the EX on TOKEN 
is released.

Regards,
Lidong
 
>                     <... proceed ...> 
>                     release TOKEN 
>   <lost one message> 
> ^^^^^^^^^^^^^^^^^ 
>                                                               Get EX on MSG 
>                                                               Get CR on ACK 
> release MSG 
>  
>  
> Abhijit 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
> the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 
>  
>  


