<?php
namespace App\Controllers;
 
use CodeIgniter\RESTful\ResourceController;
 
class Login extends ResourceController
{
    protected $format       = 'json';
    protected $modelName    = 'App\Models\Login_model';
 
    public function index()
    {
        return $this->respond($this->model->findAll(), 200);
    }
	
	public function create()
	{
		$validation =  \Config\Services::validation();
	 
		$username   = $this->request->getPost('username');
		$password = $this->request->getPost('password');
		$login_time    = $this->request->getPost('login_time');
		$login_state  = $this->request->getPost('login_state');
		 
		$data = [
			'username' => $username,
			'password' => $password,
			'login_time' => $login_time,
			'login_state' => $login_state,
		];
		 
		if($validation->run($data, 'user') == FALSE){
			$response = [
				'status' => 500,
				'error' => true,
				'data' => $validation->getErrors(),
			];
			return $this->respond($response, 500);
		} else {
			$simpan = $this->model->insertLogin($data);
			if($simpan){
				$msg = ['message' => 'Created Login successfully'];
				$response = [
					'status' => 200,
					'error' => false,
					'data' => $msg,
				];
				return $this->respond($response, 200);
			}
		}
	}
	
	public function show($id = NULL)
	{
		$get = $this->model->getLogin($id);
		if($get){
			$code = 200;
			$response = [
				'status' => $code,
				'error' => false,
				'data' => $get,
			];
		} else {
			$code = 401;
			$msg = ['message' => 'Not Found'];
			$response = [
				'status' => $code,
				'error' => true,
				'data' => $msg,
			];
		}
		return $this->respond($response, $code);
	}
 
	public function edit($id = NULL)
	{
		$get = $this->model->getLogin($id);
		if($get){
			$code = 200;
			$response = [
				'status' => $code,
				'error' => false,
				'data' => $get,
			];
		} else {
			$code = 401;
			$msg = ['message' => 'Not Found'];
			$response = [
				'status' => $code,
				'error' => true,
				'data' => $msg,
			];
		}
		return $this->respond($response, $code);
	}

	public function update($id = NULL)
	{
		$validation =  \Config\Services::validation();
		$name   = $this->request->getRawInput('username');
		$pass = $this->request->getRawInput('password');
		$logtime   = $this->request->getRawInput('login_time');
		$logstate = $this->request->getRawInput('login_state');
		$data = [
			'username' => $name,
			'password' => $pass,
			'login_time' => $logtime,
			'login_state' => $logstate,
		];
		if($validation->run($data, 'user') == FALSE){
			$response = [
				'status' => 500,
				'error' => true,
				'data' => $validation->getErrors(),
			];
			return $this->respond($response, 500);
		} else {
			$simpan = $this->model->updateLogin($data,$id);
			if($simpan){
				$msg = ['message' => 'Updated login successfully'];
				$response = [
					'status' => 200,
					'error' => false,
					'data' => $msg,
				];
				return $this->respond($response, 200);
			}
		}
	}	
	
	public function delete($id = NULL)
	{
		$hapus = $this->model->deleteLogin($id);
		if($hapus){
			$code = 200;
			$msg = ['message' => 'Deleted Login successfully'];
			$response = [
				'status' => $code,
				'error' => false,
				'data' => $msg,
			];
		} else {
			$code = 401;
			$msg = ['message' => 'Not Found'];
			$response = [
				'status' => $code,
				'error' => true,
				'data' => $msg,
			];
		}
		return $this->respond($response, $code);
	}	
	
}
?>