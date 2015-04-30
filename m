From: Abhijit Bhopatkar <abhopatk@cisco.com>
Subject: Re: Potential race in dlm based messaging md-cluster.c
Date: Fri, 01 May 2015 00:17:43 +0530
Message-ID: <554278CF.4000401@cisco.com>
References: <CAE3Hb8oss1JZ2u7g7OQQgrEtgQ1vbQou04isiS6eEqbS=uzbhw@mail.gmail.com> <CAE3Hb8qNczD30RrcHFYCR90Jf9QFD-XH=x89MAu4Dpmm80se0A@mail.gmail.com> <554251EA.3000807@suse.com> <CAE3Hb8pJ=0MB6EX5jVch28gj-gnf0Mp1wyzxBfWjzLf=SuV4sQ@mail.gmail.com> <5542763C.90202@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5542763C.90202@cisco.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/05/15 12:06 am, Abhijit Bhopatkar wrote:
> There is a possibility of a receiver losing out on messages in certain
> corner conditions. One of the buggy case is if there is are two sender
> ready with messages to be sent. Sender 1 initially gets the TOKEN lock
> and proceeds.
> After initial processing the sender of message 1 _will_ release TOKEN as
> soon as receiver releases ACK, it does not wait till ACK CR is
> re-acquired by receiver.
>
I could not come up with any solution except to add one more lock
resource for now we will call it "SYNC"

Sender 1             Sender2                  Receiver
Get EX on TOKEN      Get EX on TOKEN
Get EX on SYNC       <Wait till granted>
<Granted>

Get EX on MSG
write LVB
down MSG to CR
Get EX of ACK
<wait till granted>                           BAST for ACK
                                               Get CR on MSG
                                               read LVB
                                               <process>
                                               Queue EX on SYNC
                                               release ACK
AST for ACK
down ACK to CR
release MSG
release SYNC
release TOKEN
                                                SYNC  granted
                     <granted>
                     Get EX on SYNC
                     <wait till grant>
                                                Get EX on MSG
                                                Get CR on ACK
                                                release MSG
                                                release SYNC

                     Get EX on MSG
                     <....proceed rest>
                     release TOKEN

The key thing to note here is that the SYNC lock request is only queued
in receiver path. Having worked in dlm before I know for sure this will
work as expected.

Abhijit


